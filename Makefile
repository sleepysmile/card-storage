.PHONY: get codegen analyze test build-apk build-aab build-ios

get:
	flutter pub get

codegen:
	dart run build_runner build --delete-conflicting-outputs

analyze:
	flutter analyze

test:
	flutter test

build-apk:
	flutter build apk --release --split-per-abi

build-aab:
	flutter build appbundle --release

build-ios:
	flutter build ios --release
