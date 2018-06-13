#!/usr/bin/env groovy
// Author: Laura A. Santamaria

// Jenkinsfile written for the Information Design and Development Team at
// Rackspace for internal use. This file is intended to be run in conjunction
// with the GitHub Organization plugin for Jenkins 2.x.

// Use: Copy this file into the master branch of a repo in the IDD (IX) org.
// Before committing, update the URLs in the checkout steps.

// Pipeline variables
def isPR=false

// define github credentialsId
def credentialId=''

// define org/user name
def orgName=""

// define repository name
def repoName=""

// create the repoURL based on the org/repo Names
def repoURL="git@github.rackspace.com:${orgName}/${repoName}.git"

// Staging post
def notifyGitHub(text) {
  println BUILD_URL
  def numberPR=sh (
    script: "echo ${BRANCH_NAME} | cut -d '-' -f '2'",
    returnStdout: true
  ).trim()
  def startIt="https://github.rackspace.com/api/v3/repos/${orgName}/${repoName}/issues/"
  def startURL="${startIt}${numberPR}"
  println startURL
  def startOfEnd='/comments --data \'{"body":"'
  def endBit='"}\''
  def endURL="${startOfEnd}${text}${endBit}"
  println endURL
  def urlCurlIt="${startURL}${endURL}"
  println urlCurlIt
  withCredentials([usernameColonPassword(credentialsId: 'SVCwPAT', variable: 'MY_CREDS')]) {
    sh "curl -u ${MY_CREDS} -X POST ${urlCurlIt}"
  }
}

// Main script
node {
  // Defines a new workspace. Avoids the too-long-path issue that tox runs into
  // with the default behavior of using the commit hash instead of the build
  // tag. See https://tox.readthedocs.io/en/latest/example/jenkins.\
  // html#avoiding-the-path-too-long-error-with-long-shebang-lines
  def newWorkspace = "${JENKINS_HOME}" + "/workspace/" + "${env.BUILD_TAG}"
  ws(newWorkspace){
    stage ('Test') {
      echo "checking on status"
      println BRANCH_NAME
      def numberPR=sh (
        script: "echo ${BRANCH_NAME} | cut -d '-' -f '2'",
        returnStdout: true
      ).trim()
      println numberPR
      isPR = env.BRANCH_NAME ? env.BRANCH_NAME.startsWith("PR-") : false
      deleteDir() //clean out workspace for next run
      echo "checking out"
      // Checkout behavior explicit definition because the plugin downloads
      // things differently depending on what it's looking at.
      if (isPR) {
        checkout scm:[$class: 'GitSCM', userRemoteConfigs: [[credentialsId: credentialId, url: repoURL]]]
        sh "git fetch origin pull/'${numberPR}'/head:'${BRANCH_NAME}'"
        sh "git checkout '${BRANCH_NAME}'"
      } else {
        checkout scm:[$class: 'GitSCM', userRemoteConfigs: [[credentialsId: credentialId, url: repoURL]]]
        sh 'git checkout master'
      }
      sh 'git branch -t gh-pages origin/gh-pages'
      echo "branches are..."
      sh 'git branch -vv'
      echo "testing..."
      sshagent (credentials: ['githubSvc']) {
        env.WORKSPACE = pwd()
        sh 'cd $WORKSPACE'
        sh '$WORKSPACE/test.sh'
      }
    }
    // logic to prevent builds of PRs
    if (isPR) {
      stage ('Stage') {
        echo "staging..."
        notifyGitHub("Staging at " + BUILD_URL + "execution/node/5/ws/docs/_build/html/index.html")
      }
      echo "it was a PR, so ending here"
    } else {
      stage ('Build') {
        echo "building..."
        println currentBuild.result
        sshagent (credentials: [credentialId]) {
          sh 'cd $WORKSPACE'
          sh '$WORKSPACE/build.sh'
        }
      }
      stage ('Deploy') {
        println env.WORKSPACE
        println env.BRANCH_NAME
        sh 'cd $WORKSPACE'
        sshagent (credentials: [credentialId]) {
          sh 'cd $WORKSPACE'
          sh '$WORKSPACE/publish.sh'
        }
      }
    }
  }
}
