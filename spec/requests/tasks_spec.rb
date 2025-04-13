require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user, completed: false, status: "pending") }
  let(:token) { AuthService.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  
  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/tasks" do
    context "when user is authenticated" do
      it "returns a list of tasks" do
        get '/api/v1/tasks', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['data'].size).to eq(1)
        expect(json['data'].first['attributes']['name']).to eq(task.name)
      end
    end

    context "when token is missing" do
      it "returns a missing token error" do
        get '/api/v1/tasks'

        expect(response).to have_http_status(:unauthorized)
        expect(json['errors'].first['title']).to eq('Not Authorized')
      end
    end

    context "when token is invalid" do
      it "returns an invalid token error" do
        get '/api/v1/tasks', headers: { 'Authorization' => 'Bearer invalidtoken' }

        expect(response).to have_http_status(:unauthorized)
        expect(json['errors'].first['title']).to eq('Not Authorized')
      end
    end

    context "when token is expired" do
      let(:expired_token) { AuthService.encode({ user_id: user.id }, Time.now.to_i - 10) }
      let(:expired_headers) { { 'Authorization' => "Bearer #{expired_token}" } }

      it "returns a token expired error" do
        get '/api/v1/tasks', headers: expired_headers

        expect(response).to have_http_status(:unauthorized)
        expect(json['errors'].first['title']).to eq('Not Authorized')
      end
    end
  end

  describe "POST /api/v1/tasks" do
    let(:valid_params) { attributes_for(:task) }

    context "when task is created successfully" do
      it "creates a task and returns it" do
        post '/api/v1/tasks', params: { task: valid_params }, headers: headers

        expect(response).to have_http_status(:created)
        expect(json['data']['attributes']['name']).to eq(valid_params[:name])
      end
    end

    context "when task creation fails" do
      before do
        allow_any_instance_of(TaskService).to receive(:create).and_raise(
          ServiceError.new(["Name can't be blank"], 422)
        )
      end

      it "returns an error message" do
        post '/api/v1/tasks', params: { task: { name: nil } }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eq("Name can't be blank")
      end
    end
  end

  context "when trying to modify a completed task" do
    let!(:completed_task) { create(:task, user: user, completed: true, status: "completed") }
  
    it "returns 422 when status is changed from completed" do
      patch "/api/v1/tasks/#{completed_task.id}", params: { task: { status: "pending" } }, headers: headers
  
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].first['title']).to eq("You cannot modify a completed task.")
    end
  
    it "returns 422 when completed is set to false" do
      patch "/api/v1/tasks/#{completed_task.id}", params: { task: { completed: false } }, headers: headers
  
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'].first['title']).to eq("You cannot modify a completed task.")
    end
  end

  describe "PATCH /api/v1/tasks/:id" do
    let(:valid_params) { { name: "Updated Task" } }

    it "updates the task and returns it" do
      patch "/api/v1/tasks/#{task.id}", params: { task: valid_params }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json['data']['attributes']['name']).to eq("Updated Task")
    end

    context "when task update fails" do
      before do
        allow_any_instance_of(TaskService).to receive(:update).and_raise(
          ServiceError.new(["Invalid update"], 422)
        )
      end

      it "returns an error message" do
        patch "/api/v1/tasks/#{task.id}", params: { task: { name: nil } }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eq("Invalid update")
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    context "when task is destroyed successfully" do
      it "returns no content" do
        delete "/api/v1/tasks/#{task.id}", headers: headers

        expect(response).to have_http_status(:no_content)
        expect(Task.find_by(id: task.id)).to be_nil
      end
    end

    context "when task destruction fails" do
      before do
        allow_any_instance_of(TaskService).to receive(:destroy).and_raise(
          ServiceError.new(["Failed to destroy task"], 422)
        )
      end

      it "returns an error message" do
        delete "/api/v1/tasks/#{task.id}", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eq("Failed to destroy task")
      end
    end
  end

  describe "GET /api/v1/tasks/:id" do
    context "when task exists" do
      it "returns the task" do
        get "/api/v1/tasks/#{task.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['data']['attributes']['name']).to eq(task.name)
      end
    end

    context "when task does not exist" do
      it "returns not found" do
        get "/api/v1/tasks/999999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json['errors'].first['title']).to eq("Task not found")
      end
    end
  end
end
