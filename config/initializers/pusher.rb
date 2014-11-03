require 'pusher'

Pusher.url = "http://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api-eu.pusher.com/apps/95082"
Pusher.logger = Rails.logger
