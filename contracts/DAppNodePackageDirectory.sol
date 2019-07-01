pragma solidity ^0.4.19;

/*
    Copyright 2018, Eduardo Antuña

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/// @title DAppNodePackageDirectory Contract
/// @author Eduardo Antuña
/// @dev The goal of this smartcontrat is to keep a list of available packages 
///  to install in the DAppNode

import './Owned.sol';
import './Escapable.sol';

contract DAppNodePackageDirectory is Owned,Escapable {

    /// @param position Indicates the position of the package. position integers
    /// do not have to be consecutive. The biggest integer will be shown first.
    /// @param status - 0: Deleted, 1: Active, 2: Developing, +
    /// @param name ENS name of the package
    struct DAppNodePackage {
        uint128 position;
        uint128 status;
        string name;
    }

    bytes32 public featured;
    DAppNodePackage[] DAppNodePackages;

    event PackageAdded(uint indexed idPackage, string name);
    event PackageUpdated(uint indexed idPackage, string name);
    event StatusChanged(uint idPackage, uint128 newStatus);
    event PositionChanged(uint idPackage, uint128 newPosition);
    event FeaturedChanged(bytes32 newFeatured);

    /// @notice The Constructor assigns the `escapeHatchDestination` and the
    ///  `escapeHatchCaller`
    /// @param _escapeHatchCaller The address of a trusted account or contract
    ///  to call `escapeHatch()` to send the ether in this contract to the
    ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
    ///  cannot move funds out of `escapeHatchDestination`
    /// @param _escapeHatchDestination The address of a safe location (usu a
    ///  Multisig) to send the ether held in this contract; if a neutral address
    ///  is required, the WHG Multisig is an option:
    ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
    function DAppNodePackageDirectory(
        address _escapeHatchCaller,
        address _escapeHatchDestination
    ) 
        Escapable(_escapeHatchCaller, _escapeHatchDestination)
        public
    {
    }

    /// @notice Add a new DAppNode package
    /// @param name the ENS name of the package
    /// @param status status of the package
    /// @param position to order the packages in the UI
    /// @return the idPackage of the new package
    function addPackage (
        string name,
        uint128 status,
        uint128 position
    ) public onlyOwner returns(uint idPackage) {
        idPackage = DAppNodePackages.length++;
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.name = name;
        if (position == 0) {
            c.position = uint128(1000 * (idPackage + 1));
        } else {
            c.position = position;
        }
        c.status = status;
        // An event to notify that a new package has been added
        PackageAdded(idPackage, name);
    }

    /// @notice Update a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @param name the new ENS name of the package
    /// @param status status of the package
    /// @param position to order the packages in the UI
    function updatePackage (
        uint idPackage,
        string name,
        uint128 status,
        uint128 position
    ) public onlyOwner {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.name = name;
        c.position = position;
        c.status = status;
        // An event to notify that a package has been updated
        PackageUpdated(idPackage, name);
    }

    /// @notice Change the status of a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @param newStatus the new status of the package
    function changeStatus(
        uint idPackage,
        uint128 newStatus
    ) public onlyOwner {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.status = newStatus;
        StatusChanged(idPackage, newStatus);
    }

    /// @notice Change the status of a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @param newStatus the new status of the package
    /// @param position to order the packages in the UI
    function changePosition(
        uint idPackage,
        uint128 newPosition
    ) public onlyOwner {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.position = newPosition;
        PositionChanged(idPackage, newPosition);
    }

    /// @notice Change the list of featured packages
    /// @param _featured List of the ids of the featured packages
    /// if needed ids [5,43]: _featured = 0x052b0000000000000...
    function changeFeatured(
        bytes32 _featured
    ) public onlyOwner {
        featured = _featured;
        FeaturedChanged(_featured);
    }

    /// @notice Returns the information of a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @return name the new name of the package
    /// @return status the status of the package
    function getPackage(uint idPackage) public view returns (
        string name,
        uint128 status,
        uint128 position
    ) {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        name = c.name;
        status = c.status;
        position = c.position;
    }

    /// @notice its goal is to return the total number of DAppNode packages
    /// @return the total number of DAppNode packages
    function numberOfDAppNodePackages() view public returns (uint) {
        return DAppNodePackages.length;
    }
}
