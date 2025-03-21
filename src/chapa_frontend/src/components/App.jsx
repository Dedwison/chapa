import Footer from './Footer';
import Header from './Header';
import Item from './Item';
import { chapa_backend } from 'declarations/chapa_backend';

function App() {
  const NFTID = "asrmz-lmaaa-aaaaa-qaaeq-cai"

  return (
    <div className='App'>
      <Header />
      <main>
        <Item id={NFTID} />
      </main>
      <Footer />
    </div>
  );
}

export default App;
