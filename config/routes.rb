# frozen_string_literal: true

Rails.application.routes.draw do
  # Ping API
  get 'ping', to: 'pings#pong'
end
