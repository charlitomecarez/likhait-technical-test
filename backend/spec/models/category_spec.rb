require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is valid with a name" do
      expect(Category.new(name: "Food")).to be_valid
    end

    it "is invalid without a name" do
      category = Category.new(name: "")
      expect(category).not_to be_valid
      expect(category.errors[:name]).to be_present
    end

    it "is invalid with a duplicate name (case-insensitive)" do
      Category.create!(name: "Food")
      category = Category.new(name: "food")
      expect(category).not_to be_valid
      expect(category.errors[:name]).to be_present
    end

    it "strips surrounding whitespace from the name" do
      category = Category.create!(name: "  Food  ")
      expect(category.name).to eq("Food")
    end
  end
end
