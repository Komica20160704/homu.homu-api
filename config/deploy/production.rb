# frozen_string_literal: true

server fetch(:production_server),
       user: 'api-homu',
       roles: %w[app]
