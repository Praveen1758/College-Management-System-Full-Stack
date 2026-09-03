require "swagger_helper"

RSpec.describe "Authentication API", type: :request do
  path "/api/v1/auth/login" do
    post "Login user" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :auth, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response "200", "login successful" do
        let(:auth) do
          {
            email: "admin@example.com",
            password: "password123"
          }
        end

        run_test!
      end
    end
  end
end