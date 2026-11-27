from pathlib import Path
import streamlit as st


def afficher(contexte: dict) -> None:
    st.markdown(
        "Vue d'ensemble du référentiel **Data to Survive** (1997–2026) centré sur "
        "l'évolution des chronos et vitesses moyennes en course."
    )
    st.markdown("<br>", unsafe_allow_html=True)

    debut, fin = contexte["annees"]
    nb_saisons = fin - debut + 1

    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Circuits filtrés", len(contexte["circuits"]))
    col2.metric("Période", f"{debut}–{fin}")
    col3.metric("Saisons couvertes", nb_saisons)
    col4.metric("Ères réglementaires", 5)

    st.markdown("<br>", unsafe_allow_html=True)
    img_home = Path("assets/la_team.jpg")
    if img_home.exists():
        st.image(str(img_home), use_container_width=True)