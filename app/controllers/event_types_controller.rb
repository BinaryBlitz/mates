class EventTypesController < ApplicationController
  def index
    @event_types = EventType.all
  end
end
