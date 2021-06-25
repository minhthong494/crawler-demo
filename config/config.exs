# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

#  i = 0; a = setInterval( () => {if (i<document.body.scrollHeight) {window.scrollTo(0, i)}; i+=100; console.log(i);} , 50); setTimeout(()=> clearInterval(a), 2000);
config :crawly,
  fetcher:
    {Crawly.Fetchers.Splash,
     [
       base_url: "http://128.199.97.219:8050/execute",
       wait: 3,
       js_source:
         "i = 0; a = setInterval( () => {if (i<document.body.scrollHeight) {window.scrollTo(0, i)}; i+=100; console.log(i);} , 50); setTimeout(()=> clearInterval(a), 2000);"
     ]}

# Configures the endpoint
config :crawler_demo, CrawlerDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "whEXah16Y/sR7Q7qOuyUfyn/JpaNfObYgbY6/0Fg4HYlxwFQy6CKHsffJtDTt+1o",
  render_errors: [view: CrawlerDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CrawlerDemo.PubSub,
  live_view: [signing_salt: "SMqZ6HF/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
