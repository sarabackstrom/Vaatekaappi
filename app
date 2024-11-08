import {CssBaseline} from "@mui/material";
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { useEffect, useState } from "react";

import Vaatelomake from "./components/Vaatelomake";
import VaatekaappiMUI from "./components/VaatekaappiMUI";
import Ostoslista from "./components/Ostoslista";
import Etusivu from "./components/Etusivu";
import { getVaatteet } from "./components/vaatteet";
import DrawerMU from "./navigation/DrawerMU";

const theme = createTheme({
  palette: {
    primary: { main: '#92AA9B', contrastText: '#394942' }, // pehmeän vihreä pääväri, tummempi teksti
    secondary: { main: '#BC6A4B', contrastText: '#E3EAE5' }, // korostuksiin lämmin, vaaleaan pohjaan sointuva sävy
    background: { default: '#E3EAE5', paper: '#C4D2CA' }, // vaaleat, harmoniset taustat
    text: { primary: '#394942', secondary: '#576E60' }, // tumma vihreä ja pehmeämpi tummanvihreä tekstille
    error: { main: '#3C5241' } // "Jäänyt pieneksi" -värille punertava väri
  },
  // Värimaailma
  typography: {
    fontFamily: "'Quicksand', 'sans-serif'"
  },  // Fontti
  components: {}   // Tietyn komponentin tyyli
});

function App() {
  const [vaatteet, setVaatteet] = useState([]);
  const [virhe, setVirhe] = useState("Haetaan");

  const haeVaatteet = async () => {
    try {
      const response = await getVaatteet();
      setVaatteet(response.data);
      setVirhe("");
    } catch (error) {
      setVirhe("Tietojen haku ei onnistunut");
    }
  };

  useEffect(() => {
    haeVaatteet();
  }, []);

  const router = createBrowserRouter([
    {
      element: <DrawerMU />,
      children: [
        { path: '/', element: <Etusivu /> },
        { path: 'listaa', element: <VaatekaappiMUI vaatteet={vaatteet} /> },
        { path: 'lisaa', element: <Vaatelomake /> },
        { path: 'ostoslista', element: <Ostoslista vaatteet={vaatteet} /> },
      ],
    },
  ]);

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <RouterProvider router={router} />
    </ThemeProvider>
  );
}

export default App;
