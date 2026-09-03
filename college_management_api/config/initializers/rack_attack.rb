class Rack::Attack
  throttle("logins/ip", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end

  self.throttled_responder = lambda do |_req|
    [429, { "Content-Type" => "application/json" }, [{ error: "Too many login attempts. Please try again later." }.to_json]]
  end
end