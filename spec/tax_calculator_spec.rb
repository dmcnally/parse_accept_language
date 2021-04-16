require 'spec_helper'

module TaxCalculator

  def self.for(income:, brackets:)
    remaining_income = income.dup
    total_tax = 0

    bracket = brackets.shift
    while remaining_income > 0 and !bracket.nil?
      tax_bracket_amount, rate = bracket
      tax_bracket_amount = Float::INFINITY if tax_bracket_amount.nil?

      taxable_amount = [ tax_bracket_amount, remaining_income ].min

      tax_amount = taxable_amount * rate
      total_tax = total_tax + tax_amount

      remaining_income = remaining_income - tax_bracket_amount
      bracket = brackets.shift
    end

    total_tax
  end

end


describe TaxCalculator do

  let(:brackets) {
    [
      [ 5000, 0],
      [10000, 0.1],
      [20000, 0.2],
      [10000, 0.3],
      [nil,   0.4],
    ]
  }

  context 'when calculating tax' do

    it 'returns 0 tax when the income is 3_000' do
      result = TaxCalculator.for(income: 3_000, brackets: brackets)

      expect(result).to eq(0)
    end

    it 'returns 0 tax when the income is 5_000' do
      result = TaxCalculator.for(income: 5_000, brackets: brackets)

      expect(result).to eq(0)
    end

    it 'returns 700 tax when the income is 12_000' do
      result = TaxCalculator.for(income: 12_000, brackets: brackets)

      expect(result).to eq(700)
    end

    it 'returns 4_300 tax when the income is 34_000' do
      result = TaxCalculator.for(income: 12_000, brackets: brackets)

      expect(result).to eq(700)
    end

    it 'returns 30_000 tax when the income is 100_000' do
      result = TaxCalculator.for(income: 100_000, brackets: brackets)

      expect(result).to eq(30_000)
    end

  end

end
