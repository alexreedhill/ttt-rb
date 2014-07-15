require 'spec_helper'
require './lib/win_conditions'

describe WinConditions do
  it "determines winning cells for 3x3" do
    win_conditions = described_class.new(:board_height => 3)
    combinations = win_conditions.winning_combinations
    expected_combinations = [[0, 1, 2],
                             [0, 3, 6],
                             [3, 4, 5],
                             [1, 4, 7],
                             [6, 7, 8],
                             [2, 5, 8],
                             [0, 4, 8],
                             [2, 4, 6]]
    expect(combinations).to eq(expected_combinations)
  end

  it "determines winning cells for 4x4" do
    win_conditions = described_class.new(:board_height => 4)
    combinations = win_conditions.winning_combinations
    expected_combinations = [[0, 1, 2, 3],
                             [0, 4, 8, 12],
                             [4, 5, 6, 7],
                             [1, 5, 9, 13],
                             [8, 9, 10, 11],
                             [2, 6, 10, 14],
                             [12, 13, 14, 15],
                             [3, 7, 11, 15],
                             [0, 5, 10, 15],
                             [3, 6, 9, 12]]
    expect(combinations).to eq(expected_combinations)
  end
end
