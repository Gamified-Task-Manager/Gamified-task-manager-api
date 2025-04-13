require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:task) } 

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }

    it { should validate_inclusion_of(:status).in_array(Task::VALID_STATUSES) }
    it { should validate_inclusion_of(:priority).in_array(Task::VALID_PRIORITIES) }

    it { should validate_numericality_of(:points_awarded).is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    describe '.incomplete' do
      it 'returns tasks that are not completed' do
        incomplete_task = create(:task, status: "pending", completed: false)
        completed_task = create(:task, status: "completed", completed: true)
    
        expect(Task.incomplete).to include(incomplete_task)
        expect(Task.incomplete).not_to include(completed_task)
      end
    end
  end

  describe 'callbacks' do
    it 'downcases status before validation' do
      task = create(:task, status: 'IN_PROGRESS')
      expect(task.status).to eq('in_progress')
    end

    it 'downcases priority before validation' do
      task = create(:task, priority: 'HIGH')
      expect(task.priority).to eq('high')
    end
  end
end
