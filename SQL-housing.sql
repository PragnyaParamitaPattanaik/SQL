Select * from PORTFOLIOPROJECT.dbo.housing

--Standardise data  format
Select SaleDate, Convert(Date,SaleDate)
from PORTFOLIOPROJECT.dbo.housing
Update housing
SET SaleDate=Convert(Date,SaleDate)

--Populate Property Address Data

Select *
from PORTFOLIOPROJECT.dbo.housing
--Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PORTFOLIOPROJECT.dbo.housing a
JOIN PORTFOLIOPROJECT.dbo.housing b
on a.ParcelID=b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--Breaking the Address into Individual Column
 
 Select PropertyAddress
 from PORTFOLIOPROJECT.dbo.housing
 -----------------

 Select 
 SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address
 , SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address  
  from PORTFOLIOPROJECT.dbo.housing
----------------------------
 Select  OwnerAddress 
 from PORTFOLIOPROJECT.dbo.housing
 Select 
 PARSENAME(REPLACE(OwnerAddress,',','.'),3)
 ,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
 ,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 from PORTFOLIOPROJECT.dbo.housing


  ---------------------
  --Change y,n to Yesand No in "soldvacant" Field
  Select Distinct (SoldAsVacant),Count(SoldAsVacant)
  from PORTFOLIOPROJECT.dbo.housing
  Group by SoldAsVacant
    order by 2


Select SoldAsVacant
,CASE when SoldAsVacant='Y' THEN 'Yes'
       when SoldAsVacant='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from PORTFOLIOPROJECT.dbo.housing

Update housing
SET SoldAsVacant=CASE when SoldAsVacant='Y' THEN 'Yes'
       when SoldAsVacant='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from PORTFOLIOPROJECT.dbo.housing

--REMOVE Duplicate
WTH RowNumCTE As(
Select *,
ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	Salesprice,
	SaleDate,
	LegalReference
	ORDER BY UniqueID
	) row_num

from PORTFOLIOPROJECT.dbo.housing

DELETE
from ROWNUMCTE
Where row_num>1
				




 