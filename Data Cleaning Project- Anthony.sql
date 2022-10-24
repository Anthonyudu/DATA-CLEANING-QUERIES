/*

Cleaning Data in SQL Queries

*/

Select*
From PortfolioProject.[dbo].[NashvilleHousing]


--STANDARDIZE DATE FORMAT

Select SaleDateConverted, CONVERT(Date,SaleDate),*
From PortfolioProject.[dbo].[NashvilleHousing]

Update [dbo].[NashvilleHousing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [dbo].[NashvilleHousing]
Add SaleDateConverted Date;

Update [dbo].[NashvilleHousing]
SET SaleDateConverted = CONVERT(Date, SaleDate)


--POPULATE PROPERTY ADDRESS DATE

Select*
From PortfolioProject.[dbo].[NashvilleHousing]
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.[dbo].[NashvilleHousing] a
JOIN PortfolioProject.[dbo].[NashvilleHousing] b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From PortfolioProject.[dbo].[NashvilleHousing] a
JOIN PortfolioProject.[dbo].[NashvilleHousing] b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  --BREAKING OUT ADDRESS INTO INDIVIDUAL COULUMNS (ADDRESS, CITY, STATE)

Select*
From PortfolioProject.[dbo].[NashvilleHousing]
Where PropertyAddress is null
--order by ParcelID
  
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
,SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject.[dbo].[NashvilleHousing]


ALTER TABLE [dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [dbo].[NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

Update [dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress))



Select OwnerAddress
From PortfolioProject.[dbo].[NashvilleHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.[dbo].[NashvilleHousing]
Where OwnerAddress is not NULL

ALTER TABLE [dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [dbo].[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [dbo].[NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select*
From PortfolioProject.[dbo].[NashvilleHousing]



--CHANGED Y AND N TO YES AND NO IN "SoldAsVacant" FIELD

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
From PortfolioProject.[dbo].[NashvilleHousing]

Update [dbo].[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END

Select*
From PortfolioProject.[dbo].[NashvilleHousing]

	   --REMOVE DUPLICATES

WITH RowNumCTE AS(
Select*,
	   Row_Number() OVER (
	   PARTITION BY ParceLID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
			 		UniqueID
					) row_num

From PortfolioProject.[dbo].[NashvilleHousing]
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


--DELETE UNUSED COLUMNS

Select*
From PortfolioProject.[dbo].[NashvilleHousing]

ALTER TABLE PortfolioProject.[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.[dbo].[NashvilleHousing]
DROP COLUMN SaleDate


--FINAL CLEANED DATASET

Select*
From PortfolioProject.[dbo].[NashvilleHousing]