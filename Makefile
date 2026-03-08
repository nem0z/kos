.PHONY: build build-gateway build-node run-gateway run-node docker-build docker-push helm-install helm-uninstall clean

# Config
MODULE := github.com/nem0z/kos
REGISTRY := mem0z
TAG := latest
DOCKER := docker

# ─── Build ───────────────────────────────────────────────
build: build-gateway build-node

build-gateway:
	go build -o bin/gateway ./cmd/gateway

build-node:
	go build -o bin/node ./cmd/node

# ─── Run ─────────────────────────────────────────────────
run-gateway:
	go run ./cmd/gateway

run-node:
	go run ./cmd/node

# ─── Test ────────────────────────────────────────────────
test:
	go test ./...

test-verbose:
	go test -v ./...

# ─── Docker ──────────────────────────────────────────────

.PHONY: build build-gateway build-node run-gateway run-node docker-build docker-build-gateway docker-build-node docker-push docker-push-gateway docker-push-node helm-install helm-uninstall helm-upgrade clean

docker-build-gateway:
	$(DOCKER) build -f Dockerfile.gateway -t $(REGISTRY)/kos-gateway:$(TAG) .

docker-build-node:
	$(DOCKER) build -f Dockerfile.node -t $(REGISTRY)/kos-node:$(TAG) .

docker-push-gateway:
	$(DOCKER) push $(REGISTRY)/kos-gateway:$(TAG)

docker-push-node:
	$(DOCKER) push $(REGISTRY)/kos-node:$(TAG)

docker-build: docker-build-gateway docker-build-node

docker-push: docker-push-gateway docker-push-node

# ─── Helm ────────────────────────────────────────────────
helm-install:
	helm dependency update ./kos-chart
	helm upgrade --install kos ./kos-chart -f ./kos-chart/values.yaml

helm-uninstall:
	helm uninstall kos
	kubectl delete pvc --all

helm-lint:
	helm lint ./kos-chart

# ─── Deploy ───────────────────────────────────────────────
.PHONY: deploy
deploy: docker-build docker-push
	oc rollout restart deployment/kos-gateway
	oc rollout restart statefulset/kos-node

# ─── Clean ───────────────────────────────────────────────
clean:
	rm -rf bin/