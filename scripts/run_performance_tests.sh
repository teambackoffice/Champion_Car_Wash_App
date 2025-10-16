#!/bin/bash

# Champion Car Wash Performance Test Runner Script
# Provides easy command-line access to performance testing suite

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PERFORMANCE_RUNNER="$PROJECT_ROOT/lib/testing/performance/automation/performance_test_runner.dart"

# Default values
TEST_SUITE="all"
OUTPUT_FILE=""
VERBOSE=false
JSON_OUTPUT=false
SHOW_HELP=false

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
Champion Car Wash Performance Test Runner

Usage: $0 [OPTIONS]

OPTIONS:
    -s, --suite SUITE       Test suite to run (startup, memory, ui, api, all)
    -o, --output FILE       Output file for results
    -v, --verbose           Enable verbose output
    -j, --json              Output results in JSON format
    -h, --help              Show this help message

TEST SUITES:
    startup                 Startup time validation (< 2 seconds)
    memory                  Memory stability tests (30+ minutes)
    ui                      UI performance tests (60fps scrolling)
    api                     API performance tests (payment processing)
    all                     Run all test suites (default)

EXAMPLES:
    $0                                          # Run all tests
    $0 --suite startup --verbose               # Run startup tests with verbose output
    $0 --suite all --output results.json --json # Run all tests, save JSON results
    $0 --suite memory --output memory_report.txt # Run memory tests, save text report

REQUIREMENTS:
    - Flutter SDK installed and in PATH
    - Champion Car Wash app project setup
    - Performance testing framework initialized

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--suite)
            TEST_SUITE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -j|--json)
            JSON_OUTPUT=true
            shift
            ;;
        -h|--help)
            SHOW_HELP=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Show help if requested
if [ "$SHOW_HELP" = true ]; then
    show_help
    exit 0
fi

# Validate test suite
case $TEST_SUITE in
    startup|memory|ui|api|all)
        ;;
    *)
        print_error "Invalid test suite: $TEST_SUITE"
        print_info "Valid options: startup, memory, ui, api, all"
        exit 1
        ;;
esac

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    print_error "Flutter SDK not found in PATH"
    print_info "Please install Flutter SDK and add it to your PATH"
    exit 1
fi

# Check if we're in a Flutter project
if [ ! -f "$PROJECT_ROOT/pubspec.yaml" ]; then
    print_error "Not in a Flutter project directory"
    print_info "Please run this script from the Champion Car Wash app root directory"
    exit 1
fi

# Check if performance runner exists
if [ ! -f "$PERFORMANCE_RUNNER" ]; then
    print_error "Performance test runner not found at: $PERFORMANCE_RUNNER"
    print_info "Please ensure the performance testing framework is properly installed"
    exit 1
fi

# Build command arguments
DART_ARGS=()
DART_ARGS+=("--suite" "$TEST_SUITE")

if [ "$VERBOSE" = true ]; then
    DART_ARGS+=("--verbose")
fi

if [ "$JSON_OUTPUT" = true ]; then
    DART_ARGS+=("--json")
fi

if [ -n "$OUTPUT_FILE" ]; then
    DART_ARGS+=("--output" "$OUTPUT_FILE")
fi

# Print configuration
print_info "Champion Car Wash Performance Testing"
print_info "Test Suite: $TEST_SUITE"
if [ -n "$OUTPUT_FILE" ]; then
    print_info "Output File: $OUTPUT_FILE"
fi
if [ "$VERBOSE" = true ]; then
    print_info "Verbose Mode: Enabled"
fi
if [ "$JSON_OUTPUT" = true ]; then
    print_info "JSON Output: Enabled"
fi

echo

# Change to project directory
cd "$PROJECT_ROOT"

# Run the performance tests
print_info "Starting performance tests..."
echo

if dart run "$PERFORMANCE_RUNNER" "${DART_ARGS[@]}"; then
    echo
    print_success "Performance tests completed successfully"
    
    if [ -n "$OUTPUT_FILE" ]; then
        print_info "Results saved to: $OUTPUT_FILE"
    fi
else
    echo
    print_error "Performance tests failed"
    print_info "Check the output above for details"
    exit 1
fi