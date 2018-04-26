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

    enum DAppNodePackageStatus {Preparing, Develop, Active, Deprecated, Deleted}

    struct DAppNodePackage {
        string name;
        DAppNodePackageStatus status;
    }

    DAppNodePackage[] DAppNodePackages;

    event PackageAdded(uint indexed idPackage, string name);
    event PackageUpdated(uint indexed idPackage, string name);
    event StatusChanged(uint idPackage, DAppNodePackageStatus newStatus);

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
    /// @return the idPackage of the new package
    function addPackage (
        string name
    ) onlyOwner public returns(uint idPackage) {
        idPackage = DAppNodePackages.length++;
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.name = name;
        // An event to notify that a new package has been added
        PackageAdded(idPackage,name);
    }

    /// @notice Update a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @param name the new ENS name of the package
    function updatePackage (
        uint idPackage,
        string name
    ) onlyOwner public {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.name = name;
        // An event to notify that a package has been updated
        PackageUpdated(idPackage,name);
    }

    /// @notice Change the status of a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @param newStatus the new status of the package
    function changeStatus(
        uint idPackage,
        DAppNodePackageStatus newStatus
    ) onlyOwner public {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        c.status = newStatus;
        // An event to notify that the status of a packet has been updated
        StatusChanged(idPackage, newStatus);
    }

    /// @notice Returns the information of a DAppNode package
    /// @param idPackage the id of the package to be changed
    /// @return name the new name of the package
    /// @return status the status of the package
    function getPackage(uint idPackage) constant public returns (
        string name,
        DAppNodePackageStatus status
    ) {
        require(idPackage < DAppNodePackages.length);
        DAppNodePackage storage c = DAppNodePackages[idPackage];
        name = c.name;
        status = c.status;
    }

    /// @notice its goal is to return the total number of DAppNode packages
    /// @return the total number of DAppNode packages
    function numberOfDAppNodePackages() view public returns (uint) {
        return DAppNodePackages.length;
    }
}
