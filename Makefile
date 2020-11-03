.PHONY: up
up:
	docker-compose up -d \
		otel_collector \
		jaeger \
		zipkin

.PHONY: serve
serve:
	OTEL_RESOURCE_LABELS=service.name=foosball mix phx.server

