# frozen_string_literal: true

require 'time'
require_relative 'talk'
require_relative 'track'
require_relative '../utils/constants'

class Conference
  # Methods
  #----------------------------------------------------------------------------

  # Initialize with instance variables
  def initialize
    @talks = []
    @lightning_talks = []
    @tracks = []
    @non_selected_talks = []
  end

  # Add talk to the conference talks hash
  #
  # @param {String} name
  def add_talk(name)
    talk = Talk.new(name)

    # Arrange talks based on type
    if talk.is_lightning
      @lightning_talks << talk
    else
      @talks << talk
    end
  end

  # Add track to the conference tracks list
  #
  # @param {String} name
  def add_tracks(name)
    @tracks << Track.new(name)
  end

  # Selecting talks based on the greedy approach, so that maximum number of
  # talks can be added
  #
  # Note: Use case similar to Bin Packing Problem
  def arrange_talks
    # Sort the talks in increasing order by length
    @talks.sort_by!(&:length)

    no_track_space_left = false
    is_lightning_talks_added = false
    lightning_talks_total_length = @lightning_talks.count * LIGHTNING_TALK_LENGTH

    @talks.each do |talk|
      # If no space left then move left talks to non selected talks list
      if no_track_space_left
        @non_selected_talks << talk
        next
      end

      # If the lightning talk is not yet added & its combined length is less than
      # the current talk length
      if !is_lightning_talks_added && lightning_talks_total_length <= talk.length
        is_lightning_talks_added = add_lightning_talks_in_tracks
      end

      # If the talk can't be added to any of track then move the talk to the
      # non selected talks list
      if @tracks.none? { |track| track.add_talk(talk) }
        @non_selected_talks << talk
        no_track_space_left = true
      end
    end

    # If the lightning talks combined length is greater than all the talks length
    add_lightning_talks_in_tracks if lightning_talks_total_length > @talks.last.length
  end

  # Print the conference tracks schedule
  def print_schedule
    @tracks.each do |track|
      puts track.name

      track.sessions.each do |_session_name, session_value|
        time = Time.parse(session_value[:starts_at])
        session_value[:talks].each do |talk|
          puts "#{formatted_time(time)} #{talk.title} #{talk.length} min"

          # Convert length into seconds
          time += (talk.length * 60)
        end
      end

      puts
    end

    return unless @non_selected_talks.length > 0

    puts "List of talks that did not fit:"
    @non_selected_talks.each { |talk| puts "#{talk.title} #{talk.length}min" }
  end

  private

  # Add all lightning talks together in a single track.
  # Return true if added in any tracks
  #
  # @return {Boolean}
  def add_lightning_talks_in_tracks
    if @tracks.any? { |track| track.add_talks(@lightning_talks) }
      true
    else
      @non_selected_talks.append(*@lightning_talks)
      false
    end
  end

  # Format time in Hour:Minute:Meridian
  #
  # @param {DateTime}
  # @return {String}
  def formatted_time(time)
    time.strftime('%I:%M %p')
  end
end
