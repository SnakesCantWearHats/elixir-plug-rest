import Config
config :iex, default_prompt: ">>>"
config :lettuce, folders_to_watch: ["lib", "deps"], refresh_time: 1500
config :bolt_sips, url: "bolt://neo4j:password@neo4j:7687"
config :joken, default_signer: "secret"
