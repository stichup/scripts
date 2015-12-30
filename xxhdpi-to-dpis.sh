#!/bin/sh

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <xxhdpi_file>"
	exit 1
fi

# get filename
XXHDPI_FILE=$1

# test file existence
if [ ! -f $XXHDPI_FILE ]; then
	echo "$XXHDPI_FILE does not exist"
	exit
fi

# get height and width
XXHDPI_DIM=$(sips -g pixelHeight -g pixelWidth $XXHDPI_FILE)
XXHDPI_PXH=$(echo "$XXHDPI_DIM" | sed -n 2p | cut -d ":" -f 2 | tr -d '[[:space:]]')
XXHDPI_PXW=$(echo "$XXHDPI_DIM" | sed -n 3p | cut -d ":" -f 2 | tr -d '[[:space:]]')

# validate height and width
if [[ ( -z $XXHDPI_PXH ) || ( -z $XXHDPI_PXW ) ]]; then
	echo "Cannot obtain dimension"
	exit 1
fi

# announce file is valid
echo "An image file with height: $XXHDPI_PXH px and width: $XXHDPI_PXW px is detected."

# get xhdpi dimension
XXHDPI_TO_XHDPI=$(echo "scale=2; 2/3" | bc)
XHDPI_PXH=$(printf "%.0f" $(echo "$XXHDPI_PXH * $XXHDPI_TO_XHDPI" | bc))
XHDPI_PXW=$(printf "%.0f" $(echo "$XXHDPI_PXW * $XXHDPI_TO_XHDPI" | bc))

# get hdpi dimension
XXHDPI_TO_HDPI=$(echo "scale=2; 1/2" | bc)
HDPI_PXH=$(printf "%.0f" $(echo "$XXHDPI_PXH * $XXHDPI_TO_HDPI" | bc))
HDPI_PXW=$(printf "%.0f" $(echo "$XXHDPI_PXW * $XXHDPI_TO_HDPI" | bc))

# get mdpi dimension
XXHDPI_TO_MDPI=$(echo "scale=2; 1/3" | bc)
MDPI_PXH=$(printf "%.0f" $(echo "$XXHDPI_PXH * $XXHDPI_TO_MDPI" | bc))
MDPI_PXW=$(printf "%.0f" $(echo "$XXHDPI_PXW * $XXHDPI_TO_MDPI" | bc))

# get mldpi dimension
XXHDPI_TO_LDPI=$(echo "scale=2; 1/4" | bc)
LDPI_PXH=$(printf "%.0f" $(echo "$XXHDPI_PXH * $XXHDPI_TO_LDPI" | bc))
LDPI_PXW=$(printf "%.0f" $(echo "$XXHDPI_PXW * $XXHDPI_TO_LDPI" | bc))

# create xhdpi image
echo "Creating xhdpi image with height: $XHDPI_PXH px and width: $XHDPI_PXW px..."
sips -z $XHDPI_PXH $XHDPI_PXW $XXHDPI_FILE --out $XXHDPI_FILE.xhdpi > /dev/null 2>&1

# create hdpi image
echo "Creating hdpi image with height: $HDPI_PXH px and width: $HDPI_PXW px..."
sips -z $HDPI_PXH $HDPI_PXW $XXHDPI_FILE --out $XXHDPI_FILE.hdpi > /dev/null 2>&1

# create mdpi image
echo "Creating mdpi image with height: $MDPI_PXH px and width: $MDPI_PXW px..."
sips -z $MDPI_PXH $MDPI_PXW $XXHDPI_FILE --out $XXHDPI_FILE.mdpi > /dev/null 2>&1

# create ldpi image
echo "Creating ldpi image with height: $LDPI_PXH px and width: $LDPI_PXW px..."
sips -z $LDPI_PXH $LDPI_PXW $XXHDPI_FILE --out $XXHDPI_FILE.ldpi > /dev/null 2>&1 

echo "Done."

