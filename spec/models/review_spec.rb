# encoding: utf-8
require 'spec_helper'

describe Review do
  RATINGS = [:understood_problem, :helped_solve_problem, :knowledgeable, :value_for_money, :would_recommend]
  let(:valid_attrs) { Hash[RATINGS.map { |r| [r, 1]}].merge({ would_recommend_consulted: 1 }) }
  let(:review) { Review.create!(valid_attrs) }

  context 'awesome' do
    it 'should be false by default' do
      expect(review.awesome).to be_false
    end
  end

  context '5-star fields should be validated' do
    RATINGS.each do |field|
      it "#{field} should not allow numbers below 0" do
        review.send(:"#{field.to_s}=", -1)
        expect { review.save! }.to raise_error Mongoid::Errors::Validations
      end

      it "#{field} should not allow numbers above 5" do
        review.send(:"#{field.to_s}=", 6)
        expect { review.save! }.to raise_error Mongoid::Errors::Validations
      end

      it "#{field} should not allow numbers between 1 and 5" do
        review.send(:"#{field.to_s}=", 5)
        expect { review.save! }.not_to raise_error
      end
    end
  end

end
