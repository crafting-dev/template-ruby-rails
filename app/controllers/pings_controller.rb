# frozen_string_literal: true

class PingsController < ApplicationController
  before_action :set_ping, :set_current_time, only: :pong

  # GET /ping
  def pong
    @pong = {
      ping: @ping.presence || 'To ping, or not to ping; that is the question.',
      received_at: @current_time
    }

    render json: @pong
  end

  private

    def set_ping
      @ping = params[:ping]
    end

    def set_current_time
      @current_time = Time.current
    end
end
