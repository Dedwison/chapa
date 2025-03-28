import React from "react";
import nftLogo from "../../public/nftLogo.png";

function Header() {
    return(
        <div className="app-root-1">
            <header className="Paper-root AppBar-root AppBar-positionStatic AppBar-colorPrimary Paper-elevation4">
                <div className="Toolbar-root Toolbar-regular header-appBar-13 Toolbar-gutters">
                    <div className="header-left-4"></div>
                    <img className="header-logo-11" src={nftLogo} alt="nftLogo" />
                    <div className="header-vertical-9"></div>
                    <h5 className="Typography-root header-logo-text">NFT Market</h5>
                    <div className="header-empty-6"></div>
                    <div className="header-space-8"></div>
                    <button className="ButtonBase-root Button-root Button-text header-navButtons-3">Descubre</button>
                    <button className="ButtonBase-root Button-root Button-text header-navButtons-3">Mintea</button>
                    <button className="ButtonBase-root Button-root Button-text header-navButtons-3">Mis NFT</button>
                </div>
            </header>
        </div>
    )
}
export default Header