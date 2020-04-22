function setupValidators(validatorId, yesId, noId, containerId, ...other) {

  let validator = document.getElementById(validatorId);
  let yes = document.getElementById(yesId);
  let no = document.getElementById(noId);
  let container = document.getElementById(containerId);

  yes.addEventListener("click", () => {
    validator.setAttribute("value", "accepted");
    addAnimate(container, other);
  });

  no.addEventListener("click", () => {
    validator.setAttribute("value", "denied");
    addAnimate(container, other);
  });

  addAnimate = (container, other) => {
    other.map(x => document.getElementById(x).classList.add("animate"));
    container.classList.add("animate");
  };

}

setupValidators("acceptPassport", "passport-accept", "passport-deny", "passport-validator-container", "passport-break");
setupValidators("acceptLicenseFront", "front-license-accept", "front-license-deny", "front-license-validator-container", "license-break");
setupValidators("acceptLicenseBack", "back-license-accept", "back-license-deny", "back-license-validator-container", "back-license-break");
