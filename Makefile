.PHONY: test test-list

# Run all tests, or a specific test with: make test RUN=TestName
# RUN supports Go's -run regex matching (e.g., RUN=TestNew.*)
test:
ifdef RUN
	cd test && go test -v -timeout 30m -run $(RUN) ./...
else
	cd test && go test -v -timeout 30m ./...
endif

# List all available tests
test-list:
	@cd test && go test -list '.*' ./... 2>/dev/null | grep -E '^Test'
