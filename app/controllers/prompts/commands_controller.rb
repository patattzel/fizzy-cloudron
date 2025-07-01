class Prompts::CommandsController < ApplicationController
  def index
    @commands = []

    if stale? etag: @commands
      render layout: false
    end
  end
end
