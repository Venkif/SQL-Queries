/*

Cleaning Data in SQL Queries

*/

Select * from Housing_data

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, CONVERT(DATE,SaleDate)
FROM Housing_data

UPDATE Housing_data
SET SaleDate = CONVERT(DATE,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Housing_data
ADD SaleDateConverted date

UPDATE Housing_data
SET SaleDateConverted = CONVERT(DATE,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Housing_data
Where PropertyAddress is null
order by ParcelID


-- Doing Self Join
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data a
JOIN Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data a
JOIN Housing_data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address and City)

Select PropertyAddress
From Housing_data
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From Housing_data


ALTER TABLE Housing_data
Add PropertySplitAddress Nvarchar(255);

Update Housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing_data
Add PropertySplitCity Nvarchar(255);

Update Housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out OwnerAddress into Individual Columns (Address,City and State) using PARSENAME

Select OwnerAddress
From Housing_data

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) State
From Housing_data

ALTER TABLE Housing_data
Add OwnerSplitAddress Nvarchar(255);

Update Housing_data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing_data
Add OwnerSplitCity Nvarchar(255);

Update Housing_data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE Housing_data
Add OwnerSplitState Nvarchar(255);


Update Housing_data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct SoldasVacant, COUNT(Soldasvacant)
From Housing_data
GROUP BY SoldAsVacant
ORDER BY 2

SELECT soldasvacant,
CASE WHEN SoldAsVacant = 'N' THEN 'No'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END
From Housing_data
--WHERE SoldAsVacant = 'N'

UPDATE Housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
WHEN SoldAsVacant = 'Y' THEN 'Yes'
ELSE SoldAsVacant
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Housing_data
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE Housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
