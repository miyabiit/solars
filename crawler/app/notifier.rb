# -*- coding: utf-8 -*-

require 'active_support'
require 'active_support/core_ext'

require 'action_mailer'
require 'mongo'
require 'yaml'
require 'letter_opener'

AppRoute ||= Pathname.new(File.expand_path(File.dirname(__FILE__) + "/.."))

def load_app_libraries(load_paths)
  load_paths.each do |load_path|
    Dir[AppRoute.join(load_path).to_s + '/*.rb'].each do |path|
      require path
    end
  end
end
load_app_libraries ['app/models', 'app/lib']

def setup_mailer
  if ['production', 'staging'].include?(AppEnv)
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = YAML.load_file(AppRoute.join('config/smtp.yml').to_s).symbolize_keys
  else
    ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, location: AppRoute.join('tmp/letter_opener').to_s
    ActionMailer::Base.delivery_method = :letter_opener
  end
  ActionMailer::Base.prepend_view_path(AppRoute.join('app/mails').to_s)
end

class NewsMailer < ActionMailer::Base
  def day_mail(date = Date.yesterday)
    @target_date = date
    db_date = @target_date.strftime('%Y%m%d')
    @daily_solars = DailySolar.where(date: db_date).to_a.sort_by {|s| s.facility&.order_num || 9999}
    @daily_summary = DailySummary.where(date: db_date).first
    mail(
      to: 'solars_news@shallontec.biz',
      from: 'support@shallontec.biz',
      subject: "[Solars]発電実績レポート(#{@target_date.strftime('%Y/%m/%d')})",
    ) do |format|
      format.text
    end
  end
end

class Notifier
  class << self
    def notify_for_day
      NewsMailer.day_mail.deliver_now
    end
  end
end

if $0 === __FILE__
  AppEnv = ENV['APP_ENV'].presence || 'development'
  target_hour = 8
  setting_file = AppRoute.join('config/mailer_schedule.yml')
  if File.exists?(setting_file)
    setting = YAML.load_file(setting_file)
    disable_mail = setting['day_mail_disable'].presence
    exit if disable_mail
    target_hour = setting['day_mail_exec_hour'].presence&.to_i
    if target_hour < 0 || target_hour > 24
      raise ArgumentError.new('Invalid day_mail_exec_hour')
    end
  end
  if Time.now.hour == target_hour
    Mongoid.load!(AppRoute.join('config', 'mongoid.yml'), AppEnv)
    setup_mailer
    Notifier.notify_for_day
  end
end
