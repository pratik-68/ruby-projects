# frozen_string_literal: true

require_relative '../utils/constants'

class Talk
  attr_accessor :length, :title, :is_lightning

  # Methods
  #----------------------------------------------------------------------------

  # Initialize with instance variables
  #
  # @param {String} input
  def initialize(input)
    string_array = input.split(' ')

    @length = get_length(string_array)
    @title = string_array[0..-3].join(' ')
    @is_lightning = lightning_talk?(string_array)
  end

  private

  #----------------------------------------------------------------------------

  # Return true if talk is lightning talk
  #
  # @param {Array} string_array
  # @return {Boolean}
  def lightning_talk?(string_array)
    string_array[-2].downcase == 'lightning' && string_array[-1].downcase == 'talk'
  end

  # Return length of the given talk (unit: minutes)
  #
  # @param {Array} string_array
  # @return {String}
  def get_length(string_array)
    if lightning_talk?(string_array)
      LIGHTNING_TALK_LENGTH
    else
      Integer(string_array[-2])
    end
  end
end
