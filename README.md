# NM Application Template

This is a barebone application template demonstrating how to make use of the NM SDK.

# Application Setup

All the application specific settings are located in the file application.mk.  The
instructions are listed inside the file.  There are basically four steps:

1. Define the SDK and libraries location.
2. Specify the location of the board support package.  You can choose from predefined
BSPs from within the SDK bsp directory or create your own.
3. Specify the output file names: one for debug and the other for release.
4. Include other resources such as headers, sources, libraries or paths.
