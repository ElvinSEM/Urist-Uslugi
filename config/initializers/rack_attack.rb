# class Rack::Attack
#   throttle("req/ip", limit: 300, period: 5.minutes) { |request| request.ip }
#   throttle("logins/ip", limit: 10, period: 20.minutes) do |request|
#     request.ip if request.path.match?(%r{/users/sign_in|/api/v1/auth/login}) && request.post?
#   end
#
#   self.throttled_responder = lambda do |_request|
#     [429, { "Content-Type" => "application/json" }, [{ error: "Too many requests" }.to_json]]
#   end
# end
