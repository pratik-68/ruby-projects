# frozen_string_literal: true

# Denotes the track for the particular talks
class Track
  attr_accessor :name, :sessions

  # Constants
  #----------------------------------------------------------------------------

  # Session lists
  SESSIONS = %i[session_1 session_2].freeze

  # IN MINUTES
  MAX_TALK_LENGTH = {
    session_1: 180, # Morning session (9 AM - 12 PM)
    session_2: 240  # Afternoon session (1 PM - 5 PM)
  }.freeze

  # Methods
  #----------------------------------------------------------------------------

  # Initialize with instance variables
  #
  # @param {String} name
  def initialize(name)
    @name = name
    @sessions = {
      session_1: {
        starts_at: '09:00',
        talks: [],
        length: 0
      },
      session_2: {
        starts_at: '13:00',
        talks: [],
        length: 0
      }
    }
  end

  # Add talk in the session with available space
  # Return true if the talk is added
  #
  # @param {Talk} talk
  # @return {Boolean}
  def add_talk(talk)
    SESSIONS.any? do |session_name|
      if can_add_talk?(talk, session_name)
        @sessions[session_name][:talks] << talk
        @sessions[session_name][:length] += talk.length
      end
    end
  end

  # Add multiple talks in the session with available space
  # Return true if all the talks are added
  #
  # @param {Talk} talk
  # @return {Boolean}
  def add_talks(talks)
    SESSIONS.any? do |session_name|
      if can_add_talks?(talks, session_name)
        @sessions[session_name][:talks].append(*talks)

        talks_length = talks.sum(&:length)
        @sessions[session_name][:length] += talks_length
      end
    end
  end

  private

  # Return true if the talk can be added in the given session
  #
  # @param {Talk} talk
  # @param {Symbol} session_name
  # @return {Boolean}
  def can_add_talk?(talk, session_name)
    MAX_TALK_LENGTH[session_name] - @sessions[session_name][:length] >= talk.length
  end

  # Return true if all the talks can be added in the given session
  #
  # @param {Array<Talk>} talks
  # @param {Symbol} session_name
  # @return {Boolean}
  def can_add_talks?(talks, session_name)
    talks_length = talks.sum(&:length)

    MAX_TALK_LENGTH[session_name] - @sessions[session_name][:length] >= talks_length
  end
end
