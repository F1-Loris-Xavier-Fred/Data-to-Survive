"""
Tableau de bord Data to Survive — F1 (1997–2026).

Lancement : streamlit run app.py
"""

from pathlib import Path
import pandas as pd
import streamlit as st

st.set_page_config(
    page_title="Data to Survive — F1 (1997–2026)",
    page_icon="🏎️",
    layout="wide",
)

from onglets import accueil, circuits, ecuries, vitesse

GOLD_DIR = Path("data/03_gold")

CIRCUITS_5 = [
    "Monza",
    "Monaco",
    "Spa-Francorchamps",
    "Silverstone",
    "Suzuka",
]

ERES_REGLEMENTAIRES = {
    "Toutes les ères (1997–2026)": (1997, 2026),
    "V10 (1997–2005)": (1997, 2005),
    "V8 (2006–2013)": (2006, 2013),
    "Hybride V6 — Gen 1 (2014–2016)": (2014, 2016),
    "Aéro Large & Hybride (2017–2021)": (2017, 2021),
    "Effet de Sol (2022–2026)": (2022, 2026),
}


def charger_css(chemin: str = "assets/style.css") -> None:
    css_path = Path(chemin)
    if css_path.exists():
        st.markdown(
            f"<style>{css_path.read_text(encoding='utf-8')}</style>",
            unsafe_allow_html=True,
        )


@st.cache_data
def charger_circuits_gold() -> pd.DataFrame:
    chemin = GOLD_DIR / "circuits.csv"
    if not chemin.exists():
        return pd.DataFrame(columns=["id_circuit", "nom_circuit", "id_pays"])
    return pd.read_csv(chemin, encoding="utf-8")


@st.cache_data
def charger_status_gold() -> pd.DataFrame:
    chemin = GOLD_DIR / "status.csv"
    if not chemin.exists():
        return pd.DataFrame(columns=["id_statut", "libelle_statut"])
    return pd.read_csv(chemin, encoding="utf-8")


charger_css()

df_circuits_gold = charger_circuits_gold()
df_status_gold = charger_status_gold()

# =============================================================================
# BARRE LATÉRALE
# =============================================================================
logo_texte_path = Path("assets/logo_text_color.png")
if logo_texte_path.exists():
    st.sidebar.image(str(logo_texte_path), use_container_width=True)

st.sidebar.header("Filtres")

options_circuits = (
    sorted(df_circuits_gold["nom_circuit"].dropna().unique().tolist())
    if not df_circuits_gold.empty
    else CIRCUITS_5
)
circuits_choisis = st.sidebar.multiselect(
    "Circuits",
    options=options_circuits,
    default=options_circuits,
)

ere_choisie = st.sidebar.selectbox(
    "Ère réglementaire",
    options=list(ERES_REGLEMENTAIRES.keys()),
)
annee_min, annee_max = ERES_REGLEMENTAIRES[ere_choisie]

debut, fin = st.sidebar.slider(
    "Plage de saisons",
    min_value=annee_min,
    max_value=annee_max,
    value=(annee_min, annee_max),
)

uniquement_termines = st.sidebar.checkbox(
    "Courses / tours validés uniquement",
    value=False,
)

st.sidebar.markdown("<br>", unsafe_allow_html=True)
st.sidebar.info(
    "Périmètre : 1997–2026 sur Monza, Monaco, Spa-Francorchamps, Silverstone et Suzuka.\n\n"
)

# =============================================================================
# EN-TÊTE & ONGLETS
# =============================================================================
st.title("Data to Survive — Vitesse & Chronos F1")

contexte = {
    "circuits": circuits_choisis or options_circuits,
    "ere": ere_choisie,
    "annees": (debut, fin),
    "uniquement_termines": uniquement_termines,
    "df_circuits": df_circuits_gold,
    "df_status": df_status_gold,
}

onglet1, onglet2, onglet3, onglet4 = st.tabs(
    ["Accueil", "Vitesse & Chronos", "Circuits", "Écuries"]
)

with onglet1:
    accueil.afficher(contexte)

with onglet2:
    vitesse.afficher(contexte)

with onglet3:
    circuits.afficher(contexte)

with onglet4:
    ecuries.afficher(contexte)