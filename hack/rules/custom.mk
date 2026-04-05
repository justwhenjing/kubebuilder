##@ Custom

# env
PLATFORMS ?= linux/amd64 windows/386 darwin/arm64
KUBEBUILDER_NAME ?= kubebuilder

.PHONY: dist
dist: $(PLATFORMS) ## Build the cross-platform version
$(PLATFORMS):
	@$(eval DISTTYPE = $(subst /, ,$@))
	@$(eval GOOS = $(word 1, $(DISTTYPE)))
	@$(eval GOARCH = $(word 2, $(DISTTYPE)))
	@$(eval BINARY_NAME = $(KUBEBUILDER_NAME)_$(GOOS)_$(GOARCH)$(if $(filter windows,$(GOOS)),.exe,))
	@mkdir -p bin
	@echo Building for $(GOOS) platform, arch is $(GOARCH)...
	@GOOS=$(GOOS) GOARCH=$(GOARCH) GO111MODULE=on CGO_ENABLED=0 go build $(LD_FLAGS) \
	-o bin/$(BINARY_NAME) ./cmd/kubebuilder

.PHONY: fmt
fmt: ## Format
	@echo "===> running fmt..."
	@go fmt ./...

.PHONY: clean
clean: ## Clean
	@rm -rf bin