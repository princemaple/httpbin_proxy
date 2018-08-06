# HttpbinProxy

Commit by commit, this repo shows how to migrate an existing API service to Elixir.

Httpbin is used as the existing api service to illustrate how to gradually build an
Elixir implementation on top of that, while keeping the whole functionality working.

GenServer and DynamicSupervisor are used to demo caching (general) and implementation
comparison (business specific) functionalities.
