import requests
from bs4 import BeautifulSoup
import os
import asyncio
from playwright.async_api import async_playwright
from PyPDF2 import PdfMerger

BASE_URL = "https://docs.github.com"
DOCS_URL = f"{BASE_URL}/pt/actions"
LINKS_FILE = "links_github_actions.txt"
PDF_DIR = "pdf_temp"
FINAL_PDF = "github_actions_docs.pdf"


def extract_and_save_links():
    response = requests.get(DOCS_URL)
    soup = BeautifulSoup(response.text, "html.parser")
    nav_div = soup.find("div", {"data-container": "nav"})

    if nav_div:
        links = []
        for a in nav_div.find_all("a", href=True):
            href = a["href"]
            if href.startswith("/pt/actions/"):
                links.append(BASE_URL + href)
        # Remover duplicados mantendo ordem
        links = list(dict.fromkeys(links))
        print(f"Encontrados {len(links)} links. Salvando em {LINKS_FILE}...")
        with open(LINKS_FILE, "w", encoding="utf-8") as f:
            for link in links:
                f.write(link + "\n")
    else:
        print("Div de navegação não encontrada!")


async def save_pages_as_pdfs(links, pdf_dir):
    os.makedirs(pdf_dir, exist_ok=True)
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        for idx, url in enumerate(links):
            pdf_path = os.path.join(pdf_dir, f"page_{idx+1:03}.pdf")
            print(f"Salvando {url} em {pdf_path} ...")
            await page.goto(url)
            await page.pdf(path=pdf_path, format="A4", print_background=True)
        await browser.close()


def merge_pdfs(pdf_dir, output_pdf):
    merger = PdfMerger()
    pdf_files = sorted([os.path.join(pdf_dir, f)
                       for f in os.listdir(pdf_dir) if f.endswith(".pdf")])
    for pdf in pdf_files:
        merger.append(pdf)
    merger.write(output_pdf)
    merger.close()
    print(f"PDF único salvo como {output_pdf}")


def main():
    # Extrai e salva os links primeiro
    extract_and_save_links()
    # Lê os links do arquivo
    with open(LINKS_FILE, encoding="utf-8") as f:
        links = [line.strip() for line in f if line.strip()]
    # Baixa e salva cada página como PDF
    asyncio.run(save_pages_as_pdfs(links, PDF_DIR))
    # Junta todos em um só PDF
    merge_pdfs(PDF_DIR, FINAL_PDF)


if __name__ == "__main__":
    main()

# LINKS DA PÁGINA
# https://docs.github.com/pt/actions/about-github-actions/understanding-github-actions
# https://docs.github.com/pt/actions/about-github-actions/about-continuous-integration-with-github-actions
# https://docs.github.com/pt/actions/about-github-actions/about-continuous-deployment-with-github-actions
# https://docs.github.com/pt/actions/writing-workflows/quickstart
# https://docs.github.com/pt/actions/writing-workflows/about-workflows
# https://docs.github.com/pt/actions/writing-workflows/using-workflow-templates
# https://docs.github.com/pt/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow
# https://docs.github.com/pt/actions/writing-workflows/choosing-when-your-workflow-runs/using-conditions-to-control-job-execution
# https://docs.github.com/pt/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows
# https://docs.github.com/pt/actions/writing-workflows/choosing-where-your-workflow-runs/choosing-the-runner-for-a-job
# https://docs.github.com/pt/actions/writing-workflows/choosing-where-your-workflow-runs/running-jobs-in-a-container
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/using-jobs-in-a-workflow
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/using-pre-written-building-blocks-in-your-workflow
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/using-github-cli-in-workflows
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/adding-scripts-to-your-workflow
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/evaluate-expressions-in-workflows-and-actions
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/passing-information-between-jobs
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/setting-a-default-shell-and-working-directory
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/using-environments-for-deployment
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/running-variations-of-jobs-in-a-workflow
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows
# https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/storing-and-sharing-data-from-a-workflow
# https://docs.github.com/pt/actions/writing-workflows/workflow-syntax-for-github-actions
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/re-running-workflows-and-jobs
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/canceling-a-workflow
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/disabling-and-enabling-a-workflow
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/skipping-workflow-runs
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/deleting-a-workflow-run
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/downloading-workflow-artifacts
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/removing-workflow-artifacts
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/approving-workflow-runs-from-public-forks
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/approving-workflow-runs-from-private-forks
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-deployments/viewing-deployment-history
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-deployments/reviewing-deployments
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-deployments/creating-custom-deployment-protection-rules
# https://docs.github.com/pt/actions/managing-workflow-runs-and-deployments/managing-deployments/configuring-custom-deployment-protection-rules
# https://docs.github.com/pt/actions/sharing-automations/avoiding-duplication
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/about-custom-actions
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/creating-a-docker-container-action
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/creating-a-javascript-action
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/creating-a-composite-action
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/metadata-syntax-for-github-actions
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/dockerfile-support-for-github-actions
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/setting-exit-codes-for-actions
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/releasing-and-maintaining-actions
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/publishing-actions-in-github-marketplace
# https://docs.github.com/pt/actions/sharing-automations/creating-actions/developing-a-third-party-cli-action
# https://docs.github.com/pt/actions/sharing-automations/reusing-workflows
# https://docs.github.com/pt/actions/sharing-automations/creating-workflow-templates-for-your-organization
# https://docs.github.com/pt/actions/sharing-automations/sharing-actions-and-workflows-from-your-private-repository
# https://docs.github.com/pt/actions/sharing-automations/sharing-actions-and-workflows-with-your-organization
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/about-monitoring-workflows
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/notifications-for-workflow-runs
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/using-the-visualization-graph
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/viewing-workflow-run-history
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/viewing-job-execution-time
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/adding-a-workflow-status-badge
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/using-workflow-run-logs
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/about-troubleshooting-workflows
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/actions-limits
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/using-copilot-to-troubleshoot-workflows
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/pt/actions/monitoring-and-troubleshooting-workflows/troubleshooting-workflows/working-with-support-for-github-actions
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-github-hosted-runners/about-github-hosted-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-github-hosted-runners/monitoring-your-current-jobs
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-github-hosted-runners/customizing-github-hosted-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-larger-runners/about-larger-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-larger-runners/managing-larger-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-larger-runners/controlling-access-to-larger-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/using-larger-runners/running-jobs-on-larger-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/connecting-to-a-private-network/about-private-networking-with-github-hosted-runners
# https://docs.github.com/pt/actions/using-github-hosted-runners/connecting-to-a-private-network/using-an-api-gateway-with-oidc
# https://docs.github.com/pt/actions/using-github-hosted-runners/connecting-to-a-private-network/using-wireguard-to-create-a-network-overlay
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/communicating-with-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/supported-architectures-and-operating-systems-for-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/usage-limits-for-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/running-scripts-before-or-after-a-job
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/customizing-the-containers-used-by-jobs
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/using-a-proxy-server-with-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/using-labels-with-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/using-self-hosted-runners-in-a-workflow
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/managing-access-to-self-hosted-runners-using-groups
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/monitoring-and-troubleshooting-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners/removing-self-hosted-runners
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/about-actions-runner-controller
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/using-actions-runner-controller-runners-in-a-workflow
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/troubleshooting-actions-runner-controller-errors
# https://docs.github.com/pt/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/about-support-for-actions-runner-controller
# https://docs.github.com/pt/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions
# https://docs.github.com/pt/actions/security-for-github-actions/security-guides/about-secrets
# https://docs.github.com/pt/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions
# https://docs.github.com/pt/actions/security-for-github-actions/security-guides/automatic-token-authentication
# https://docs.github.com/pt/actions/security-for-github-actions/security-guides/using-githubs-security-features-to-secure-your-use-of-github-actions
# https://docs.github.com/pt/actions/security-for-github-actions/using-artifact-attestations/using-artifact-attestations-to-establish-provenance-for-builds
# https://docs.github.com/pt/actions/security-for-github-actions/using-artifact-attestations/using-artifact-attestations-and-reusable-workflows-to-achieve-slsa-v1-build-level-3
# https://docs.github.com/pt/actions/security-for-github-actions/using-artifact-attestations/enforcing-artifact-attestations-with-a-kubernetes-admission-controller
# https://docs.github.com/pt/actions/security-for-github-actions/using-artifact-attestations/verifying-attestations-offline
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-hashicorp-vault
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-jfrog
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-pypi
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers
# https://docs.github.com/pt/actions/security-for-github-actions/security-hardening-your-deployments/using-openid-connect-with-reusable-workflows
# https://docs.github.com/pt/actions/use-cases-and-examples/creating-an-example-workflow
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-go
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-java-with-ant
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-java-with-gradle
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-java-with-maven
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-net
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-nodejs
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-powershell
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-python
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-ruby
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-rust
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-swift
# https://docs.github.com/pt/actions/use-cases-and-examples/building-and-testing/building-and-testing-xamarin-applications
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-with-github-actions
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-nodejs-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-python-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-java-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-net-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-php-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-docker-to-azure-app-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-to-azure-static-web-app
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-to-azure-kubernetes-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-to-amazon-elastic-container-service
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/deploying-to-google-kubernetes-engine
# https://docs.github.com/pt/actions/use-cases-and-examples/deploying/installing-an-apple-certificate-on-macos-runners-for-xcode-development
# https://docs.github.com/pt/actions/use-cases-and-examples/publishing-packages/about-packaging-with-github-actions
# https://docs.github.com/pt/actions/use-cases-and-examples/publishing-packages/publishing-docker-images
# https://docs.github.com/pt/actions/use-cases-and-examples/publishing-packages/publishing-java-packages-with-gradle
# https://docs.github.com/pt/actions/use-cases-and-examples/publishing-packages/publishing-java-packages-with-maven
# https://docs.github.com/pt/actions/use-cases-and-examples/publishing-packages/publishing-nodejs-packages
# https://docs.github.com/pt/actions/use-cases-and-examples/project-management/using-github-actions-for-project-management
# https://docs.github.com/pt/actions/use-cases-and-examples/project-management/adding-labels-to-issues
# https://docs.github.com/pt/actions/use-cases-and-examples/project-management/closing-inactive-issues
# https://docs.github.com/pt/actions/use-cases-and-examples/project-management/commenting-on-an-issue-when-a-label-is-added
# https://docs.github.com/pt/actions/use-cases-and-examples/project-management/scheduling-issue-creation
# https://docs.github.com/pt/actions/use-cases-and-examples/using-containerized-services/about-service-containers
# https://docs.github.com/pt/actions/use-cases-and-examples/using-containerized-services/creating-postgresql-service-containers
# https://docs.github.com/pt/actions/use-cases-and-examples/using-containerized-services/creating-redis-service-containers
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/automating-migration-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/extending-github-actions-importer-with-custom-transformers
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/supplemental-arguments-and-settings
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-azure-devops-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-bamboo-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-bitbucket-pipelines-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-circleci-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-gitlab-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-jenkins-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/using-github-actions-importer-to-automate-migrations/migrating-from-travis-ci-with-github-actions-importer
# https://docs.github.com/pt/actions/migrating-to-github-actions/manually-migrating-to-github-actions/migrating-from-azure-pipelines-to-github-actions
# https://docs.github.com/pt/actions/migrating-to-github-actions/manually-migrating-to-github-actions/migrating-from-circleci-to-github-actions
# https://docs.github.com/pt/actions/migrating-to-github-actions/manually-migrating-to-github-actions/migrating-from-gitlab-cicd-to-github-actions
# https://docs.github.com/pt/actions/migrating-to-github-actions/manually-migrating-to-github-actions/migrating-from-jenkins-to-github-actions
# https://docs.github.com/pt/actions/migrating-to-github-actions/manually-migrating-to-github-actions/migrating-from-travis-ci-to-github-actions
# https://docs.github.com/pt/actions/administering-github-actions/usage-limits-billing-and-administration
# https://docs.github.com/pt/actions/administering-github-actions/viewing-github-actions-metrics
# https://docs.github.com/pt/actions/administering-github-actions/sharing-workflows-secrets-and-runners-with-your-organization
# https://docs.github.com/pt/actions/guides

