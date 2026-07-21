build:
	flutter build apk --debug

build_runner:
	cd packages/rocketchat_sdk
	dart run build_runner build

.PHONY: build build_runner
