import streamlit as st


def afficher(contexte: dict) -> None:
    debut, fin = contexte["annees"]
    st.subheader("Vitesse & Chronos en course")
    st.markdown(
        f"Analyse des chronos et vitesses moyennes sur **{contexte['ere']}** ({debut}–{fin})."
    )

    col1, col2, col3 = st.columns(3)
    col1.metric("Circuits sélectionnés", len(contexte["circuits"]))
    col2.metric("Plage saisons", f"{debut}–{fin}")
    col3.metric(
        "Filtre validés",
        "Actif" if contexte["uniquement_termines"] else "Tous statuts",
    )

    st.info("Graphiques de chronos et vitesses à brancher sur les données Gold d'Axe 1.")