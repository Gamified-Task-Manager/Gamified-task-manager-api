require 'rails_helper'

RSpec.describe TaskService do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }
  let(:task) { create(:task, user: user) }

  describe '#create' do
    context 'when task creation is successful' do
      let(:params) { attributes_for(:task) }

      it 'returns the created task' do
        created_task = service.create(params)
        expect(created_task).to be_a(Task)
        expect(created_task.name).to eq(params[:name])
      end
    end

    context 'when task creation fails' do
      let(:params) { { name: nil } } # invalid data

      it 'raises a ServiceError with validation errors' do
        expect {
          service.create(params)
        }.to raise_error(ServiceError) { |e|
          expect(e.errors).to include("Name can't be blank")
          expect(e.status).to eq(422)
        }
      end
    end
  end

  describe '#update' do
    context 'when update is successful' do
      let(:task) { create(:task, user: user, status: 'pending', completed: false) }
      let(:params) { { name: 'Updated Task' } }
  
      it 'updates the task' do
        updated_task = service.update(task, params)
        expect(updated_task.name).to eq('Updated Task')
      end
    end

    context 'when update fails' do
      let(:task) { create(:task, user: user, status: 'pending', completed: false) }
      let(:params) { { name: nil } }
  
      it 'raises a ServiceError with validation errors' do
        expect {
          service.update(task, params)
        }.to raise_error(ServiceError) { |e|
          expect(e.errors).to include("Name can't be blank")
          expect(e.status).to eq(422)
        }
      end 
    end
  end

  describe '#destroy' do
    context 'when task is successfully destroyed' do
      it 'destroys the task' do
        task_id = task.id
        service.destroy(task)
        
        # Confirm the task is gone from the database
        expect(Task.find_by(id: task_id)).to be_nil
      end
    end  

    context 'when task destruction fails' do
      before do
        allow(task).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end
    
      it 'raises a ServiceError' do
        expect {
          service.destroy(task)
        }.to raise_error(ServiceError) { |e|
          expect(e.errors).to include("Failed to destroy task")
          expect(e.status).to eq(422)
        }
      end
    end
  end
end
