#!/bin/bash
die () {
    echo "$*" >&2
    exit 1
}

# Parse script arguments
for i in "$@"
do
case "$i" in
    --configuration=*)
    CONFIGURATION="${i#*=}"
    shift # past argument=value
    ;;
    --version=*)
    VERSION="${i#*=}"
    shift # past argument=value
    ;;
    --package-root=*)
    PACKAGE_ROOT="${i#*=}"
    shift # past argument=value
    ;;
    --output=*)
    OUTPUT="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

CONFIGURATION="${CONFIGURATION:=Debug}"
if [ -z "$VERSION" ]; then
    die "--version was not set"
fi

# Directories
THISDIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT="$( cd "$THISDIR"/../../.. ; pwd -P )"
SRC="$ROOT/src"
OUT="$ROOT/out"
DOTNET_TOOL="shared/DotnetTool"

if [ -z "$PACKAGE_ROOT" ]; then
    PACKAGE_ROOT="$OUT/$DOTNET_TOOL/nupkg/$CONFIGURATION"
fi

echo "Creating dotnet tool package..."

if [ -z "$OUTPUT" ]; then
    dotnet pack "$SRC/$DOTNET_TOOL/DotnetTool.csproj" \
        /p:Configuration="$CONFIGURATION" \
        /p:PackageVersion="$VERSION" \
        /p:PublishDir="$PACKAGE_ROOT/"
else
    dotnet pack "$SRC/$DOTNET_TOOL/DotnetTool.csproj" \
        /p:Configuration="$CONFIGURATION" \
        /p:PackageVersion="$VERSION" \
        /p:PublishDir="$PACKAGE_ROOT/" \
        --output "$OUTPUT"
fi

echo "Dotnet tool pack complete."
