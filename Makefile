sync-til:
	./scripts/sync-til.sh
	./scripts/build-til-index.sh
	./scripts/build-til-digests.sh "$(shell git rev-parse HEAD)"
