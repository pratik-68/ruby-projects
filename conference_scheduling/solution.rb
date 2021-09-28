# frozen_string_literal: true

require_relative 'input'
require_relative 'lib/conference'
require_relative 'utils/constants'

# Main Function
def main
  conference = Conference.new

  # Add tracks for the conference
  (1..DEFAULT_TRACKS_COUNT).each { |i| conference.add_tracks("Track #{i}") }

  # Add talks for the conference
  INPUT_LIST.each { |talk| conference.add_talk(talk) }

  conference.arrange_talks
  conference.print_schedule
end

main
