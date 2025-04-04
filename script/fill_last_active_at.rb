#!/usr/bin/env ruby

require_relative "../config/environment"

ApplicationRecord.with_each_tenant do |tenant|
  Bubble.find_each do |bubble|
    bubble.update! last_active_at: bubble.events.last&.created_at || Time.current
  end
end
