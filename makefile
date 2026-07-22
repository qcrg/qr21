build:
	flutter build apk

build_runner:
	cd packages/rocketchat_sdk
	dart run build_runner build

cp: build
	cp build/app/outputs/flutter-apk/app-release.apk ~/qr21-$(shell yaml2json pubspec.yaml | jq .version -r).apk

.PHONY: build build_runner
