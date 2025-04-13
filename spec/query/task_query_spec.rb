require 'rails_helper'

RSpec.describe TaskQuery do
  let!(:user) { create(:user) }

  # Sample tasks for filters/sorting
  let!(:task1) do
    create(
      :task,
      user: user,
      name: "Alpha Task",
      priority: 'high',
      status: 'pending',
      completed: false,
      due_date: Date.today + 2.days
    )
  end

  let!(:task2) do
    create(
      :task,
      user: user,
      name: "Beta Task",
      priority: 'medium',
      status: 'in_progress',
      completed: true,
      due_date: Date.today + 5.days
    )
  end

  let!(:task3) do
    create(
      :task,
      user: user,
      name: "Gamma Task",
      priority: 'low',
      status: 'completed',
      completed: false,
      due_date: Date.today + 1.day
    )
  end

  describe '.for_user' do
    it 'returns tasks for the user' do
      result = TaskQuery.for_user(user)
      expect(result).to include(task1, task2, task3)
    end

    it 'filters by status' do
      result = TaskQuery.for_user(user, { status: 'pending' })
      expect(result).to contain_exactly(task1)
    end

    it 'filters by priority' do
      result = TaskQuery.for_user(user, { priority: 'medium' })
      expect(result).to contain_exactly(task2)
    end

    it 'filters by completed' do
      result = TaskQuery.for_user(user, { completed: "true" })
    
      expect(result).to include(task2, task3) 
      expect(result).not_to include(task1)    
    end

    it 'filters by due_before' do
      result = TaskQuery.for_user(user, { due_before: Date.today + 2.days })
      expect(result).to include(task1, task3)
      expect(result).not_to include(task2)
    end

    it 'sorts by due_date ascending (soonest first)' do
      result = TaskQuery.for_user(user, { sort_by: 'due_date' })
      expect(result).to eq([task3, task1, task2])
    end

    it 'sorts by priority (high → medium → low)' do
      result = TaskQuery.for_user(user, { sort_by: 'priority' })
      expect(result).to eq([task1, task2, task3])
    end

    it 'sorts by name (alphabetical A → Z)' do
      result = TaskQuery.for_user(user, { sort_by: 'name' })
      expect(result.map(&:name)).to eq(["Alpha Task", "Beta Task", "Gamma Task"])
    end
  end

  describe '.incomplete_for_user' do
    it 'returns incomplete tasks' do
      result = TaskQuery.incomplete_for_user(user)
      expect(result).to include(task1)
      expect(result).not_to include(task2, task3)
    end    
  end

  describe '.high_priority_for_user' do
    it 'returns high priority tasks' do
      result = TaskQuery.high_priority_for_user(user)
      expect(result).to include(task1)
      expect(result).not_to include(task2, task3)
    end
  end

  describe '.by_status_for_user' do
    it 'returns tasks by status' do
      result = TaskQuery.by_status_for_user(user, 'pending')
      expect(result).to contain_exactly(task1)
    end
  end
end
