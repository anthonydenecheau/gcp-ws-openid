
# -----------------------------------------------------------------------------
# database
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# instances
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# cloud run
# -----------------------------------------------------------------------------
module "scc-api" {
    source = "./api"

    gcr_igm = {
        region = var.region
        project = "ws-pedigree-api"
    }
}


# -----------------------------------------------------------------------------
# cloud build
# -----------------------------------------------------------------------------
module "scc-cicd" {
    source = "./cicd"

}
