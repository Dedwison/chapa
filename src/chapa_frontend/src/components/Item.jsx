import React, { useEffect, useState } from "react";
import nftLogo from "../nftLogo.png";
import { Actor, HttpAgent  } from "@dfinity/agent";
import { idlFactory } from "../../../declarations/nft";
import { Principal } from "@dfinity/principal";

function Item(props) {
  const [name, setName] = useState();
  const [owner, setOwner] = useState();
  const [image, setImage] = useState();

  const id = Principal.fromText(props.id);
  const localHost = "http://localhost:3000/";

  const loadNFT = async () => {

    const agent = new HttpAgent({
      host: localHost
    });


    // Verificar si estamos en desarrollo local (no en la IC mainnet)
    if (process.env.DFX_NETWORK !== "ic") {
      try {
        await agent.fetchRootKey().catch(err => {
          console.warn("No se pudo obtener la clave raíz. Asegúrate de que tu réplica local esté ejecutándose");
          console.error(err);
        });
      } catch (err) {
        console.warn("Error al intentar obtener la clave raíz");
        console.error(err);
      }
    }

    // Crea una instancia del Actor NFT utilizando la interfaz IDL importada
    // Este Actor permite interactuar con el canister NFT específico
    const NFTActor = Actor.createActor(idlFactory, {
      agent,
      canisterId: id,
    });

    const name = await NFTActor.getName();
    const ownerId = await NFTActor.getOwner();
    // Obtiene los datos binarios de la imagen NFT desde el canister
    const imageData = await NFTActor.getAsset();
    // Convierte los datos binarios a un array de bytes (Uint8Array) para su procesamiento
    const imageContent = new Uint8Array(imageData);
    // Crea una URL de objeto temporal en el navegador para mostrar la imagen,
    // convirtiendo el array de bytes en un Blob con tipo de contenido imagen PNG
    const image = URL.createObjectURL(new Blob([imageContent.buffer], {type: "image/png"}));

    setName(name);
    setOwner(ownerId.toText());
    setImage(image)
  };


  useEffect(()=>{
      loadNFT()
  }, []);

  return (
    <div className="disGrid-item">
      <div className="disPaper-root disCard-root makeStyles-root-17 disPaper-elevation1 disPaper-rounded">
        <img
          className="disCardMedia-root makeStyles-image-19 disCardMedia-media disCardMedia-img"
          src={image}
        />
        <div className="disCardContent-root">
          <h2 className="disTypography-root makeStyles-bodyText-24 disTypography-h5 disTypography-gutterBottom">
          {name}<span className="purple-text"></span>
          </h2>
          <p className="disTypography-root makeStyles-bodyText-24 disTypography-body2 disTypography-colorTextSecondary">
            Owner: {owner}
          </p>
        </div>
      </div>
    </div>
  );
}

export default Item;